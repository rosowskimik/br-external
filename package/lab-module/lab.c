#include <linux/array_size.h>
#include <linux/compiler_types.h>
#include <linux/dev_printk.h>
#include <linux/sprintf.h>
#include <linux/kstrtox.h>
#include <linux/device/devres.h>
#include <linux/errno.h>
#include <linux/io.h>
#include <linux/kobject.h>
#include <linux/module.h>
#include <linux/of.h>
#include <linux/platform_device.h>
#include <linux/regmap.h>
#include <linux/slab.h>
#include <linux/string.h>
#include <linux/sysfs.h>
#include <linux/types.h>

#define LAB_DRV_NAME "first_device"

// clang-format off
#define LAB_DRV_ARG1	0x00
#define LAB_DRV_ARG2	0x04
#define LAB_DRV_OP	0x08
#define LAB_DRV_RES	0x0C

#define LAB_DRV_OP_ADD	'+'
#define LAB_DRV_OP_SUB	'-'
#define LAB_DRV_OP_MUL	'*'
// clang-format on

static const struct regmap_config lab_drv_regmap_config = {
	.reg_bits = 32,
	.val_bits = 32,
	.reg_stride = 4,
	.max_register = LAB_DRV_RES,
};

struct lab_drv {
	struct kobject kobj;
	struct regmap *map;
	struct device *dev;
};

static ssize_t reg_show(struct kobject *kobj, u32 reg, char *buf)
{
	struct lab_drv *priv = container_of((void *)kobj, struct lab_drv, kobj);
	u32 val;
	int ret;

	ret = regmap_read(priv->map, reg, &val);
	if (ret) {
		dev_err(priv->dev, "Failed to read register 0x%02X\n", reg);
		return ret;
	}

	return sprintf(buf, "%d\n", val);
}

static ssize_t reg_store(struct kobject *kobj, u32 reg, const char *buf,
			 size_t count)
{
	struct lab_drv *priv = container_of((void *)kobj, struct lab_drv, kobj);
	u32 val;
	int ret;

	ret = kstrtou32(buf, 10, &val);
	if (ret)
		return ret;

	ret = regmap_write(priv->map, reg, val);
	if (ret) {
		dev_err(priv->dev, "Failed to write registetr 0x%02X\n", reg);
		return ret;
	}
	return count;
}

#define LAB_DRV_ATTR(_name, _reg)                                           \
	static ssize_t _name##_show(struct kobject *kobj,                   \
				    struct kobj_attribute *attr, char *buf) \
	{                                                                   \
		struct lab_drv *priv =                                      \
			container_of((void *)kobj, struct lab_drv, kobj);   \
		dev_info(priv->dev, "Reading " __stringify(_name) "\n");    \
		return reg_show(kobj, _reg, buf);                           \
	}                                                                   \
	static ssize_t _name##_store(struct kobject *kobj,                  \
				     struct kobj_attribute *attr,           \
				     const char *buf, size_t count)         \
	{                                                                   \
		struct lab_drv *priv =                                      \
			container_of((void *)kobj, struct lab_drv, kobj);   \
		dev_info(priv->dev, "Writing " __stringify(_name) "\n");    \
		return reg_store(kobj, _reg, buf, count);                   \
	}                                                                   \
	static struct kobj_attribute _name##_attribute = __ATTR_RW(_name)

LAB_DRV_ATTR(arg1, LAB_DRV_ARG1);
LAB_DRV_ATTR(arg2, LAB_DRV_ARG2);
LAB_DRV_ATTR(op, LAB_DRV_OP);
LAB_DRV_ATTR(res, LAB_DRV_RES);

// clang-format off
static struct attribute *lab_drv_attrs[] = {
	&arg1_attribute.attr,
	&arg2_attribute.attr,
	&op_attribute.attr,
	&res_attribute.attr,
	{},
};
// clang-format on

static const struct attribute_group lab_drv_attr_group = {
	.attrs = lab_drv_attrs
};

static const struct attribute_group *lab_drv_attr_groups[] = {
	&lab_drv_attr_group,
	{},
};

static const struct kobj_type lab_drv_ktype = {
	.sysfs_ops = &kobj_sysfs_ops,
	.default_groups = lab_drv_attr_groups,
};

static int lab_drv_probe(struct platform_device *pdev)
{
	struct lab_drv *priv;
	void __iomem *regs;
	int res;

	priv = devm_kzalloc(&pdev->dev, sizeof(*priv), GFP_KERNEL);
	if (!priv)
		return -ENOMEM;

	priv->dev = &pdev->dev;

	regs = devm_platform_ioremap_resource(pdev, 0);
	if (IS_ERR(regs))
		return dev_err_probe(&pdev->dev, PTR_ERR(regs),
				     "Failed to map registers\n");

	priv->map =
		devm_regmap_init_mmio(&pdev->dev, regs, &lab_drv_regmap_config);
	if (IS_ERR(priv->map))
		return dev_err_probe(&pdev->dev, PTR_ERR(priv->map),
				     "Failed to initialize regmap\n");

	res = kobject_init_and_add(&priv->kobj, &lab_drv_ktype, kernel_kobj,
				   LAB_DRV_NAME);
	if (res) {
		kobject_put(&priv->kobj);
		return dev_err_probe(&pdev->dev, res,
				     "Failed to create kobject\n");
	}

	platform_set_drvdata(pdev, priv);

	dev_info(&pdev->dev, "Device initialized\n");

	return 0;
}

static void lab_drv_remove(struct platform_device *pdev)
{
	struct lab_drv *priv = platform_get_drvdata(pdev);
	kobject_put(&priv->kobj);
}

// clang-format off
static const struct of_device_id lab_drv_match[] = {
	{ .compatible = "put,first_device", },
	{},
};
MODULE_DEVICE_TABLE(of, lab_drv_match);
// clang-format on

// clang-format off
static struct platform_driver lab_drv = {
	.probe	= lab_drv_probe,
    .remove = lab_drv_remove,
	.driver	= {
		.name		= LAB_DRV_NAME,
		.owner		= THIS_MODULE,
		.of_match_table = lab_drv_match,
	}
};
// clang-format on

module_platform_driver(lab_drv);

MODULE_LICENSE("GPL");
MODULE_AUTHOR("Mikołaj Rosowski");
MODULE_DESCRIPTION("Lab driver");
