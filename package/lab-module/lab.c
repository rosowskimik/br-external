#include <linux/init.h>
#include <linux/module.h>
#include <linux/printk.h>

static int __init lab_init(void)
{
	pr_info("Module init\n");
	return 0;
}

static void __exit lab_exit(void)
{
	pr_info("Module exit\n");
}

module_init(lab_init);
module_exit(lab_exit);

MODULE_LICENSE("GPL");
MODULE_AUTHOR("Mikołaj Rosowski");
MODULE_DESCRIPTION("Lab driver");
