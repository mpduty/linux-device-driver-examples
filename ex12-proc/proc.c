/*
 * proc.c
 *
 * proc example
 *
 * Copyright (C) 2005 Shakthi Kannan
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.

 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.

 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
 *
 */


#include <linux/module.h>
#include <linux/kernel.h>
#include <linux/proc_fs.h>
#include <linux/fs.h>

MODULE_LICENSE ("GPL");

struct proc_dir_entry *proc_file_entry;

static const struct file_operations proc_file_fops = {
	.owner = THIS_MODULE,
};

int hello_read_procmem (char *buf, char **start, off_t offset, int count, int *eof, void *data)
{
  int len = 0;
  len = sprintf (buf, "Hey, there! hello from hello_read_procmem\n");
  *eof = 1;
  return len;
}


static void hello_create_proc (void)
{
  proc_create("hello", 0, NULL, &proc_file_fops);
}

int init_module (void)
{
  hello_create_proc();
  printk (KERN_INFO "hello_create_proc() done ...\n");
  return 0;
}

void cleanup_module (void)
{
  remove_proc_entry ("hello", NULL);
  printk (KERN_INFO "removed proc module\n");
}
