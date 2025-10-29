#include <linux/init.h>
#include <linux/module.h>
#include <linux/printk.h>

static int __init lab_init(void)
{
	pr_emerg("emerg\n");
	pr_alert("alert\n");
	pr_crit("crit\n");
	pr_warn("warn\n");
	pr_notice("notice\n");
	pr_info("info\n");
	pr_debug("debug\n");
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
