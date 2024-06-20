#!/usr/bin/env python3

import os
import shutil
from datetime import datetime


def main():
    dotfiles_dir = os.path.dirname(__file__)
    home_dir = os.path.expanduser('~')
    newsys_file = os.path.join(dotfiles_dir, '.newsys')
    backup_name = f'backup_{datetime.now().strftime("%Y%m%d_%H%M%S")}'
    backup_dir = os.path.join(dotfiles_dir, backup_name)
    os.mkdir(backup_dir)
    with open(newsys_file, 'r') as f:
        for line in f:
            fname = line.rstrip()
            backup_src = os.path.join(home_dir, fname)
            backup_dst = os.path.join(backup_dir, fname)
            # Only backup files if they exist
            if os.path.exists(backup_src):
                shutil.copy2(backup_src, backup_dst)
                os.remove(backup_src)
                print(f'backed up {backup_src} to {backup_dir}')

            # Create the link even if they may not exist before.
            link_src = os.path.join(dotfiles_dir, fname)
            link_dst = backup_src
            os.symlink(link_src, link_dst)
            print(f'created symlink at {link_dst} pointing to {link_src}')


if __name__ == "__main__":
    main()
