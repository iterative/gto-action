import sys
import os
import argparse
from gto.api import check_ref
from gto.constants import SEPARATOR_IN_NAME
from dvc.repo import Repo

# Create a parser and add argument to it
parser = argparse.ArgumentParser(description='Process some data.')
parser.add_argument('arg', choices=['path', 'desc', 'type'], help='An argument to specify output type')
args = parser.parse_args()

events = check_ref(".", os.environ["GITHUB_REF"])
if not events:
    print("No events found", file=sys.stderr)
    exit(0)
    
name = events[0].artifact
if SEPARATOR_IN_NAME in name:
    subdir, subname = name.split(SEPARATOR_IN_NAME)
else:
    subdir, subname = "", name

path = subdir
dvcroot = None
while not dvcroot and path:
    if os.path.isdir(os.path.join(path, Repo.DVC_DIR)):
        dvcroot = path
    path = os.path.dirname(path)

# checking if the top directory is a dvc repo
if not dvcroot and os.path.isdir(os.path.join(path, Repo.DVC_DIR)):
    dvcroot = path

if dvcroot is None:
    print("No dvcroot found", file=sys.stderr)
    exit(0)

subdir = subdir[len(dvcroot):]
r = Repo(dvcroot)
annotation = r.artifacts.read().get(os.path.join(subdir, "dvc.yaml"), {}).get(subname, None)

if not annotation:
    print("No annotation found", file=sys.stderr)
    exit(0)

if args.arg == 'desc':
    if value := annotation.desc:
        print(value)
elif args.arg == 'path':
    if value := annotation.path:
        print(value)
elif args.arg == 'type':
    if value := annotation.type:
        print(value)
