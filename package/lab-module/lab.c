#include <linux/module.h>
#include <linux/platform_device.h>
#include <linux/of.h>
#include <linux/ioport.h>
#include <linux/device.h>
#include <linux/dev_printk.h>
#include <linux/errno.h>

static int lab_drv_probe(struct platform_device *pdev)
{
	struct device *dev = &pdev->dev;
	struct device_node *np = dev->of_node;
	struct resource *mem_res;
	const char *label;
	u32 repeat;
	u32 ratio[2];

	if (!(mem_res = platform_get_resource(pdev, IORESOURCE_MEM, 0))) {
		dev_err(dev, "Failed to get memory resource\n");
		return -ENXIO;
	}

	dev_info(dev, "Memory start: 0x%08llX\n", mem_res->start);
	dev_info(dev, "Memory end: 0x%08llX\n", mem_res->end);
	dev_info(dev, "Size: 0x%lld bytes\n", resource_size(mem_res));

	if (of_property_read_string(np, "label", &label))
		dev_warn(dev, "Failed to read 'label'\n");

	if (of_property_read_u32(np, "repeat", &repeat))
		dev_warn(dev, "Failed to read 'repeat'\n");

	if (of_property_read_u32_array(np, "ratio", ratio, ARRAY_SIZE(ratio)))
		dev_warn(dev, "Failed to read 'ratio'\n");

	dev_info(dev, "string label = \"%s\"\n", label);
	dev_info(dev, "u32 repeat = <%d>\n", repeat);
	dev_info(dev, "u32 array ratio = <%d %d>\n", ratio[0], ratio[1]);

	return 0;
}

static void lab_drv_remove(struct platform_device *pdev)
{
	pr_debug("Remove\n");
}

// clang-format off
static const struct of_device_id lab_drv_match[] = {
	{ .compatible = "put,first_device", },
	{},
};
MODULE_DEVICE_TABLE(of, lab_drv_match);

static struct platform_driver lab_drv = {
	.probe	= lab_drv_probe,
	.remove	= lab_drv_remove,
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
