#!/usr/bin/env bash

pmset noidle &
PMSETPID=$!

mkdir -p ~/EcoAssist_files
cd ~/EcoAssist_files || { echo "Could not change directory to EcoAssist_files. Command could not be run. Please install EcoAssist manually: https://github.com/PetervanLunteren/EcoAssist"; exit 1; }

ECO="EcoAssist"
if [ -d "$ECO" ]; then
  echo "Dir ${ECO} already exists! Skipping this step."
else
  echo "Dir ${ECO} does not exist! Clone repo..."
  git clone https://github.com/PetervanLunteren/EcoAssist.git
fi

CAM="cameratraps"
if [ -d "$CAM" ]; then
  echo "Dir ${CAM} already exists! Skipping this step."
else
  echo "Dir ${CAM} does not exist! Clone repo..."
  git clone https://github.com/Microsoft/cameratraps
  cd cameratraps || { echo "Could not change directory. Command could not be run. Please install EcoAssist manually: https://github.com/PetervanLunteren/EcoAssist"; exit 1; }
  git checkout e40755ec6f3b34e6eefa1306d5cd6ce605e0f5ab
  cd .. || { echo "Could not change directory. Command could not be run. Please install EcoAssist manually: https://github.com/PetervanLunteren/EcoAssist"; exit 1; }
fi

AI4="ai4eutils"
if [ -d "$AI4" ]; then
  echo "Dir ${AI4} already exists! Skipping this step."
else
  echo "Dir ${AI4} does not exist! Clone repo..."
  git clone https://github.com/Microsoft/ai4eutils
  cd ai4eutils || { echo "Could not change directory. Command could not be run. Please install EcoAssist manually: https://github.com/PetervanLunteren/EcoAssist"; exit 1; }
  git checkout c8692a2ed426a189ef3c1b3a5a21ae287c032a1d
  cd .. || { echo "Could not change directory. Command could not be run. Please install EcoAssist manually: https://github.com/PetervanLunteren/EcoAssist"; exit 1; }
fi

MD="md_v4.1.0.pb"
if [ -f "$MD" ]; then
  echo "File ${MD} already exists! Skipping this step."
else
  echo "File ${MD} does not exist! Downloading file..."
  curl --tlsv1.2 --keepalive --output md_v4.1.0.pb https://lilablobssc.blob.core.windows.net/models/camera_traps/megadetector/md_v4.1.0/md_v4.1.0.pb
fi

PATH2CONDA_SH=`conda info | grep 'base environment' | cut -d ':' -f 2 | xargs | cut -d ' ' -f 1`
PATH2CONDA_SH+="/etc/profile.d/conda.sh"
echo "Path to conda.sh: $PATH2CONDA_SH"
# shellcheck source=src/conda.sh
source "$PATH2CONDA_SH"

conda env remove -n ecoassistcondaenv
conda create -n ecoassistcondaenv python==3.7 -y
conda activate ecoassistcondaenv
pip install --upgrade pip setuptools wheel
pip install --upgrade pip
conda install -c conda-forge requests=2.26.0 -y
pip install -r EcoAssist/requirements.txt
conda deactivate

kill $PMSETPID

echo "

The installation is done! You can close this window now and proceed to open EcoAssist by double clicking the EcoAssist_files/EcoAssist/open_EcoAssist.command file.

"
