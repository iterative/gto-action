import os
from gto.api import check_ref
from gto.constants import SEPARATOR_IN_NAME
from dvc import Repo

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
    exit

os.chdir(dvcroot)
subdir = subdir[len(dvcroot):]

r = Repo.Repo(".")

annotation = r.artifacts.read().get(os.path.join(subdir, "dvc.yaml"), {}).get(subname, None)

if annotation:
    if value := annotation.desc:
        os.environ["DESCRIPTION"] = value
    if value := annotation.path:
        os.environ["ARTIFACT_PATH"] = value
    if value := annotation.type:
        os.environ["TYPE"] = value
