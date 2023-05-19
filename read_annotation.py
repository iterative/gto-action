import os
from gto.api import check_ref
from gto.constants import SEPARATOR_IN_NAME
from dvc.repo import Repo

name = check_ref(".", os.environ["GITHUB_REF"])[0].artifact
if SEPARATOR_IN_NAME in name:
    subdir, subname = name.split(SEPARATOR_IN_NAME)
else:
    subdir, subname = "", name

path = subdir
dvcroot = None
while not dvcroot or path:
    if os.path.isdir(os.path.join(path, Repo.DVC_DIR)):
        dvcroot = path
    path = os.path.dirname(path)

if not dvcroot:
    print("DVC root not found. Won't check for annotations.")
    exit

subdir = subdir[len(dvcroot):]
r = Repo(dvcroot)
annotation = r.artifacts.read().get(os.path.join(subdir, "dvc.yaml"), {}).get(subname, None)

if annotation:
    export = []
    if value := annotation.desc:
        export.append(f'export DESCRIPTION="{value}"\n')
    if value := annotation.path:
        export.append(f'export ARTIFACT_PATH="{value}"\n')
    if value := annotation.type:
        export.append(f'export TYPE="{value}"\n')

    with open("set_vars.sh", "w") as f:
        f.writelines(export)
