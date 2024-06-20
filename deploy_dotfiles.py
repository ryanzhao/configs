#!/usr/bin/env python3

import os
import shutil
from datetime import datetime

if __name__ == "__main__":
    cwd = os.getcwd()
    home_dir = os.path.expanduser('~')
    newsys_file = os.path.join(cwd, '.newsys')
    backup_name = f'backup_{datetime.now().strftime("%Y%m%d_%H%M%S")}'
    backup_dir = os.path.join(cwd, backup_name)
    os.mkdir(backup_dir)
    with open(newsys_file, 'r') as f:
        for line in f:
            fname = line.rstrip()
            backup_src = os.path.join(home_dir, fname)
            if os.path.exists(backup_src):
                backup_dst = os.path.join(backup_dir, fname)
                shutil.copy2(backup_src, backup_dst)
                os.remove(backup_src)
                print(f'backed up {backup_src} to {backup_dir}')
                link_src = os.path.join(cwd, fname)
                link_dst = backup_src
                os.symlink(link_src, link_dst)
                print(f'created symlink at {link_dst} pointing to {link_src}')
