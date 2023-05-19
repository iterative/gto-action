import os
from gto.api import check_ref
from gto.constants import SEPARATOR_IN_NAME
from dvc import Repo

artifact = check_ref(".", os.environ["GITHUB_REF"])[0].artifact
if SEPARATOR_IN_NAME in artifact:
    subdir, name = artifact.split(SEPARATOR_IN_NAME)
else:
    subdir, name = "", artifact

r = Repo.Repo(".")

annotation = r.artifacts.read().get(os.path.join(subdir, "dvc.yaml"), {}).get(name, None)

if annotation:
    if value := annotation.desc:
        os.environ["DESCRIPTION"] = value
    if value := annotation.path:
        os.environ["ARTIFACT_PATH"] = value
    if value := annotation.type:
        os.environ["TYPE"] = value

