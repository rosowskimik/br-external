#include <linux/array_size.h>
#include <linux/module.h>
#include <linux/platform_device.h>
#include <linux/of.h>
#include <linux/io.h>
#include <linux/types.h>
#include <linux/device/devres.h>
#include <linux/errno.h>
#include <linux/dev_printk.h>
#include <linux/compiler_types.h>
#include <linux/regmap.h>

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
	struct regmap *map;
};

static int lab_drv_regs_print(struct platform_device *pdev)
{
	static int regs[] = { LAB_DRV_ARG1, LAB_DRV_ARG2, LAB_DRV_OP,
			      LAB_DRV_RES };
	struct lab_drv *priv = platform_get_drvdata(pdev);
	u32 val[4];
	int res;

	res = regmap_multi_reg_read(priv->map, regs, val, 4);
	if (res)
		return res;

	dev_info(&pdev->dev, "arg1: %d, arg2: %d, op: %c, res: %d\n", val[0],
		 val[1], (char)val[2], val[3]);
	return 0;
}

static int lab_drv_do_op(struct platform_device *pdev, u32 arg1, u32 arg2,
			 u32 op)
{
	struct lab_drv *priv = platform_get_drvdata(pdev);
	struct reg_sequence regs[] = {
		{ LAB_DRV_ARG1, arg1 },
		{ LAB_DRV_ARG2, arg2 },
		{ LAB_DRV_OP, op },
	};

	return regmap_multi_reg_write(priv->map, regs, ARRAY_SIZE(regs));
}

static int lab_drv_probe(struct platform_device *pdev)
{
	struct lab_drv *priv;
	void __iomem *regs;
	int res;

	priv = devm_kzalloc(&pdev->dev, sizeof(*priv), GFP_KERNEL);
	if (!priv)
		return -ENOMEM;

	regs = devm_platform_ioremap_resource(pdev, 0);
	if (IS_ERR(regs))
		return dev_err_probe(&pdev->dev, PTR_ERR(regs),
				     "Failed to map registers\n");

	priv->map =
		devm_regmap_init_mmio(&pdev->dev, regs, &lab_drv_regmap_config);
	if (IS_ERR(priv->map))
		return dev_err_probe(&pdev->dev, PTR_ERR(priv->map),
				     "Failed to initialize regmap\n");

	platform_set_drvdata(pdev, priv);

	dev_info(&pdev->dev, "Device initialized\n");

	res = lab_drv_regs_print(pdev);
	if (res)
		return dev_err_probe(&pdev->dev, res,
				     "Failed to read registers\n");

	res = lab_drv_do_op(pdev, 2, 3, LAB_DRV_OP_ADD);
	if (res)
		return dev_err_probe(&pdev->dev, res,
				     "Failed to write operation\n");

	res = lab_drv_regs_print(pdev);
	if (res)
		return dev_err_probe(&pdev->dev, res,
				     "Failed to read registers\n");

	res = lab_drv_do_op(pdev, 5, 4, LAB_DRV_OP_SUB);
	if (res)
		return dev_err_probe(&pdev->dev, res,
				     "Failed to write operation\n");

	res = lab_drv_regs_print(pdev);
	if (res)
		return dev_err_probe(&pdev->dev, res,
				     "Failed to read registers\n");

	res = lab_drv_do_op(pdev, 3, 5, LAB_DRV_OP_MUL);
	if (res)
		return dev_err_probe(&pdev->dev, res,
				     "Failed to write operation\n");

	res = lab_drv_regs_print(pdev);
	if (res)
		return dev_err_probe(&pdev->dev, res,
				     "Failed to read registers\n");

	return 0;
}

// clang-format off
static const struct of_device_id lab_drv_match[] = {
	{ .compatible = "put,first_device", },
	{},
};
MODULE_DEVICE_TABLE(of, lab_drv_match);

static struct platform_driver lab_drv = {
	.probe	= lab_drv_probe,
	.driver	= {
		.name		= "lab_driver",
		.owner		= THIS_MODULE,
		.of_match_table = lab_drv_match,
	}
};
// clang-format on

module_platform_driver(lab_drv);

MODULE_LICENSE("GPL");
MODULE_AUTHOR("Mikołaj Rosowski");
MODULE_DESCRIPTION("Lab driver");
