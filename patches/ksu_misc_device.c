/* ksu_misc_device.c - /dev/kernelsu misc device for kernel <5.10
 * Bypasses seccomp that blocks the magic install syscall on old kernels.
 * Manager/ksud can open("/dev/kernelsu") to get a driver FD instead.
 */
#include <linux/version.h>
#if LINUX_VERSION_CODE < KERNEL_VERSION(5, 10, 0)

#include <linux/miscdevice.h>
#include <linux/fs.h>
#include <linux/slab.h>
#include <linux/sched.h>
#include <linux/uidgid.h>

/* Forward declarations from supercall.c */
struct ksu_driver_context {
    unsigned long permissions;
};

extern long ksu_supercall_handle_ioctl(const struct file *filp, unsigned int cmd, void __user *argp);

static int ksu_misc_release(struct inode *inode, struct file *filp)
{
    kfree(filp->private_data);
    return 0;
}

static int ksu_misc_open(struct inode *inode, struct file *filp)
{
    struct ksu_driver_context *ctx;
    ctx = kzalloc(sizeof(*ctx), GFP_KERNEL);
    if (!ctx)
        return -ENOMEM;
    ctx->permissions = 0;
    filp->private_data = ctx;
    pr_info("KSU: /dev/kernelsu opened by pid %d uid %d\n",
            current->pid, current_uid().val);
    return 0;
}

static long ksu_misc_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
{
    return ksu_supercall_handle_ioctl(filp, cmd, (void __user *)arg);
}

static const struct file_operations ksu_misc_fops = {
    .owner = THIS_MODULE,
    .open = ksu_misc_open,
    .unlocked_ioctl = ksu_misc_ioctl,
    .compat_ioctl = ksu_misc_ioctl,
    .release = ksu_misc_release,
};

static struct miscdevice ksu_misc_dev = {
    .minor = MISC_DYNAMIC_MINOR,
    .name = "kernelsu",
    .fops = &ksu_misc_fops,
    .mode = 0666,
};

static int ksu_misc_registered;

void __init ksu_misc_device_init(void)
{
    int ret = misc_register(&ksu_misc_dev);
    if (ret) {
        pr_err("KSU: failed to register /dev/kernelsu: %d\n", ret);
    } else {
        ksu_misc_registered = 1;
        pr_info("KSU: /dev/kernelsu registered successfully\n");
    }
}

void ksu_misc_device_exit(void)
{
    if (ksu_misc_registered) {
        misc_deregister(&ksu_misc_dev);
        pr_info("KSU: /dev/kernelsu deregistered\n");
    }
}

#else
/* Kernel 5.10+ has seccomp cache bypass, no misc device needed */
void __init ksu_misc_device_init(void) {}
void ksu_misc_device_exit(void) {}
#endif
