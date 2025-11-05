#include <linux/cdev.h>
#include <linux/device.h>
#include <linux/device/class.h>
#include <linux/uaccess.h>
#include <linux/err.h>
#include <linux/errno.h>
#include <linux/fs.h>
#include <linux/gfp_types.h>
#include <linux/init.h>
#include <linux/module.h>
#include <linux/moduleparam.h>
#include <linux/mutex.h>
#include <linux/printk.h>
#include <linux/slab.h>
#include <linux/stat.h>
#include <linux/types.h>

static uint bufsize = 1024;
module_param(bufsize, uint, S_IRUGO);
MODULE_PARM_DESC(bufsize, "Max buffer size");

#define LAB_DEVICE_NAME "tac"
#define LAB_DEVICE_CLASS "tac"

static struct {
	char *data;
	size_t len;
	struct mutex lock;
} buffer;

static struct class *lab_class;
static struct cdev lab_cdev;
static dev_t lab_dev;

static int lab_open(struct inode *inode, struct file *filp)
{
	pr_debug("Open call\n");
	return 0;
}

static int lab_release(struct inode *inode, struct file *filp)
{
	pr_debug("Release call\n");
	return 0;
}

static ssize_t lab_write(struct file *filp, const char __user *buf,
			 size_t count, loff_t *pos)
{
	ssize_t ret;

	if (*pos >= bufsize)
		return 0;

	if (*pos + count > bufsize)
		count = bufsize - *pos;

	if (mutex_lock_interruptible(&buffer.lock)) {
		return -ERESTARTSYS;
	}

	if (copy_from_user(buffer.data, buf, count) != 0) {
		ret = -EFAULT;
		goto write_exit;
	}

	*pos += count;
	buffer.len = *pos;

	ret = count;

write_exit:
	mutex_unlock(&buffer.lock);
	return ret;
}

static ssize_t lab_read(struct file *filp, char __user *buf, size_t count,
			loff_t *pos)
{
	ssize_t ret = 0;

	if (mutex_lock_interruptible(&buffer.lock)) {
		return -ERESTARTSYS;
	}

	if (*pos >= buffer.len)
		goto read_exit;

	if (*pos + count > bufsize)
		count = buffer.len - (*pos);

	for (size_t i = 0; i < count; ++i) {
		if (put_user(buffer.data[buffer.len - i - 1], &buf[i])) {
			ret = -EFAULT;
			goto read_exit;
		}
	}

	*pos += count;
	ret = count;

read_exit:
	mutex_unlock(&buffer.lock);
	return ret;
}

static const struct file_operations fops = {
	.owner = THIS_MODULE,
	.open = lab_open,
	.release = lab_release,
	.write = lab_write,
	.read = lab_read,
};

static int __init lab_init(void)
{
	int rc;
	struct device *dev;

	if ((rc = alloc_chrdev_region(&lab_dev, 0, 1, LAB_DEVICE_NAME))) {
		pr_err("Failed to allocate devnum (err %d)\n", rc);
		goto init_alloc_chrdev;
	};

	if (IS_ERR((lab_class = class_create(LAB_DEVICE_CLASS)))) {
		rc = PTR_ERR(lab_class);
		pr_err("Failed to create device class (err %d)\n", rc);
		goto init_class_create;
	}

	cdev_init(&lab_cdev, &fops);
	lab_cdev.owner = THIS_MODULE;

	if ((rc = cdev_add(&lab_cdev, lab_dev, 1))) {
		pr_err("Failed to add character device (err %d)\n", rc);
		goto init_cdev_add;
	}

	if (IS_ERR((dev = device_create(lab_class, NULL, lab_dev, NULL,
					LAB_DEVICE_NAME)))) {
		rc = PTR_ERR(dev);
		pr_err("Failed to create device file (err %d)\n", rc);
		goto init_device_create;
	}

	if (!(buffer.data = kmalloc(bufsize, GFP_KERNEL))) {
		rc = -ENOMEM;
		pr_err("Failed to allocate buffer memory\n");
		goto init_alloc_buffer;
	}

	mutex_init(&buffer.lock);
	pr_info("Module initialized with bufsize %u\n", bufsize);

	return 0;

init_alloc_buffer:
	device_destroy(lab_class, lab_dev);
init_device_create:
	cdev_del(&lab_cdev);
init_cdev_add:
	class_destroy(lab_class);
init_class_create:
	unregister_chrdev_region(lab_dev, 1);
init_alloc_chrdev:
	return rc;
}

static void __exit lab_exit(void)
{
	mutex_lock(&buffer.lock);

	kfree(buffer.data);
	device_destroy(lab_class, lab_dev);
	cdev_del(&lab_cdev);
	class_destroy(lab_class);
	unregister_chrdev_region(lab_dev, 1);

	mutex_unlock(&buffer.lock);
}

module_init(lab_init);
module_exit(lab_exit);

MODULE_LICENSE("GPL");
MODULE_AUTHOR("Mikołaj Rosowski");
MODULE_DESCRIPTION("Lab driver");
