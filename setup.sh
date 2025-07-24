#!/bin/bash

# ASCII Art Header
echo "
MMMMMMMM               MMMMMMMM                       SSSSSSSSSSSSSSS
M:::::::M             M:::::::M                     SS:::::::::::::::S
M::::::::M           M::::::::M                    S:::::SSSSSS::::::S
M:::::::::M         M:::::::::M                    S:::::S     SSSSSSS
M::::::::::M       M::::::::::M    ccccccccccccccccS:::::S                eeeeeeeeeeee        eeeeeeeeeeee
M:::::::::::M     M:::::::::::M  cc:::::::::::::::cS:::::S              ee::::::::::::ee    ee::::::::::::ee
M:::::::M::::M   M::::M:::::::M c:::::::::::::::::c S::::SSSS          e::::::eeeee:::::ee e::::::eeeee:::::ee
M::::::M M::::M M::::M M::::::Mc:::::::cccccc:::::c  SS::::::SSSSS    e::::::e     e:::::ee::::::e     e:::::e
M::::::M  M::::M::::M  M::::::Mc::::::c     ccccccc    SSS::::::::SS  e:::::::eeeee::::::ee:::::::eeeee::::::e
M::::::M   M:::::::M   M::::::Mc:::::c                    SSSSSS::::S e:::::::::::::::::e e:::::::::::::::::e
M::::::M    M:::::M    M::::::Mc:::::c                         S:::::Se::::::eeeeeeeeeee  e::::::eeeeeeeeeee
M::::::M     MMMMM     M::::::Mc::::::c     ccccccc            S:::::Se:::::::e           e:::::::e
M::::::M               M::::::Mc:::::::cccccc:::::cSSSSSSS     S:::::Se::::::::e          e::::::::e
M::::::M               M::::::M c:::::::::::::::::cS::::::SSSSSS:::::S e::::::::eeeeeeee   e::::::::eeeeeeee
M::::::M               M::::::M  cc:::::::::::::::cS:::::::::::::::SS   ee:::::::::::::e    ee:::::::::::::e
MMMMMMMM               MMMMMMMM    cccccccccccccccc SSSSSSSSSSSSSSS       eeeeeeeeeeeeee      eeeeeeeeeeeeee
"
echo "Starting McSee Artifacts setup script..."
echo ""

# Define the base workspace directory
WORKSPACE_DIR="mcsee-artifacts-workspace"

# --- Step 1: Create the main workspace directory ---
echo "[>] Creating the main workspace directory: $WORKSPACE_DIR"
mkdir -p "$WORKSPACE_DIR"
if [ $? -eq 0 ]; then
    : # No-op to keep the if block structure
else
    echo "Error: Failed to create $WORKSPACE_DIR. Exiting."
    exit 1
fi
echo "" # Add a blank line for better readability

# Navigate into the workspace directory
cd "$WORKSPACE_DIR" || { echo "Error: Could not navigate into $WORKSPACE_DIR. Exiting."; exit 1; }

# --- Step 2: Create and clone into 'comsec-group' directory ---
COMSEC_GROUP_DIR="comsec-group"
COMSEC_REPO="https://github.com/comsec-group/mcsee.git"

echo "[>] Creating directory: $COMSEC_GROUP_DIR"
mkdir -p "$COMSEC_GROUP_DIR"
if [ $? -eq 0 ]; then
    : # No-op
else
    echo "Error: Failed to create $COMSEC_GROUP_DIR. Exiting."
    exit 1
fi

echo "[>] Cloning repository '$COMSEC_REPO' into '$COMSEC_GROUP_DIR'"
# Suppress verbose git output, just show the custom message
git clone "$COMSEC_REPO" "$COMSEC_GROUP_DIR" > /dev/null 2>&1
if [ $? -eq 0 ]; then
    echo "[>] Successfully cloned $COMSEC_REPO."
else
    echo "Error: Failed to clone $COMSEC_REPO. Please check your internet connection and repository URL. Exiting."
    exit 1
fi
echo ""

# --- Step 3: Create and clone into 'mcsee-artifacts-github' directory ---
MCSEE_ARTIFACTS_GITHUB_DIR="mcsee-artifacts-github"
MCSEE_ARTIFACTS_REPOS=(
    "https://github.com/mcsee-artifacts/ddr4-decoder.git"
    "https://github.com/mcsee-artifacts/ddr5-decoder.git"
    "https://github.com/mcsee-artifacts/ddr5-udimm-interposer-pcb.git"
    "https://github.com/mcsee-artifacts/mcsee-experiments.git"
    "https://github.com/mcsee-artifacts/spd-decoder.git"
    "https://github.com/mcsee-artifacts/xmldig2csv-converter.git"
)

echo "[>] Creating directory: $MCSEE_ARTIFACTS_GITHUB_DIR"
mkdir -p "$MCSEE_ARTIFACTS_GITHUB_DIR"
if [ $? -eq 0 ]; then
    : # No-op
else
    echo "Error: Failed to create $MCSEE_ARTIFACTS_GITHUB_DIR. Exiting."
    exit 1
fi

echo "[>] Cloning repositories into '$MCSEE_ARTIFACTS_GITHUB_DIR'"
for repo in "${MCSEE_ARTIFACTS_REPOS[@]}"; do
    # Extract repository name from URL to use as directory name
    repo_name=$(basename "$repo" .git)
    echo "  [>] Cloning $repo into $MCSEE_ARTIFACTS_GITHUB_DIR/$repo_name..."
    # Suppress verbose git output, just show the custom message
    git clone "$repo" "$MCSEE_ARTIFACTS_GITHUB_DIR/$repo_name" > /dev/null 2>&1
    if [ $? -eq 0 ]; then
        echo "  [>] Successfully cloned $repo_name."
    else
        echo "  Warning: Failed to clone $repo_name. Skipping."
    fi
done

# Add specific cloning for sledgehammer
SLEDGEHAMMER_REPO="https://github.com/mcsee-artifacts/sledgehammer.git"
SLEDGEHAMMER_TARGET_DIR="$MCSEE_ARTIFACTS_GITHUB_DIR/mcsee-experiments/e2-sledgehammer/code"
echo "  [>] Creating directory: $SLEDGEHAMMER_TARGET_DIR"
mkdir -p "$SLEDGEHAMMER_TARGET_DIR"
if [ $? -eq 0 ]; then
    : # No-op
else
    echo "Error: Failed to create $SLEDGEHAMMER_TARGET_DIR. Exiting."
    exit 1
fi
echo "  [>] Cloning $SLEDGEHAMMER_REPO into $SLEDGEHAMMER_TARGET_DIR..."
git clone "$SLEDGEHAMMER_REPO" "$SLEDGEHAMMER_TARGET_DIR" > /dev/null 2>&1
if [ $? -eq 0 ]; then
    echo "  [>] Successfully cloned $(basename "$SLEDGEHAMMER_REPO" .git)."
else
    echo "  Warning: Failed to clone $(basename "$SLEDGEHAMMER_REPO" .git). Skipping."
fi

# Add specific cloning for rowpress
ROWPRESS_REPO="https://github.com/mcsee-artifacts/rowpress.git"
ROWPRESS_TARGET_DIR="$MCSEE_ARTIFACTS_GITHUB_DIR/mcsee-experiments/e4-rowpress/code"
echo "  [>] Creating directory: $ROWPRESS_TARGET_DIR"
mkdir -p "$ROWPRESS_TARGET_DIR"
if [ $? -eq 0 ]; then
    : # No-op
else
    echo "Error: Failed to create $ROWPRESS_TARGET_DIR. Exiting."
    exit 1
fi
echo "  [>] Cloning $ROWPRESS_REPO into $ROWPRESS_TARGET_DIR..."
git clone "$ROWPRESS_REPO" "$ROWPRESS_TARGET_DIR" > /dev/null 2>&1
if [ $? -eq 0 ]; then
    echo "  [>] Successfully cloned $(basename "$ROWPRESS_REPO" .git)."
else
    echo "  Warning: Failed to clone $(basename "$ROWPRESS_REPO" .git). Skipping."
fi
echo ""

# --- Step 4: Download and extract the Zenodo archive ---
ZENODO_URL="https://zenodo.org/records/15739732/files/mcsee-data.tar?download=1"
ARCHIVE_FILENAME="mcsee-data.tar" # Expected filename after download
DATA_DIR="mcsee-data" # New directory for extracted data

echo "[>] Downloading and extracting mcsee-data archive from Zenodo"
echo "  [>] Downloading $ZENODO_URL..."
# Use curl to download and save the file with the correct name
curl -L -o "$ARCHIVE_FILENAME" "$ZENODO_URL"
if [ $? -eq 0 ]; then
    echo "  [>] Successfully downloaded $ARCHIVE_FILENAME."
else
    echo "Error: Failed to download $ARCHIVE_FILENAME. Please check the URL and your internet connection. Exiting."
    exit 1
fi

echo "  [>] Creating directory for extracted data: $DATA_DIR"
mkdir -p "$DATA_DIR"
if [ $? -eq 0 ]; then
    : # No-op
else
    echo "Error: Failed to create $DATA_DIR. Exiting."
    exit 1
fi

echo "  [>] Extracting $ARCHIVE_FILENAME into $DATA_DIR..."
# Extract to the new directory and suppress specific tar warnings by redirecting stderr to null
tar -xf "$ARCHIVE_FILENAME" -C "$DATA_DIR" 2>/dev/null
if [ $? -eq 0 ]; then
    echo "  [>] Successfully extracted $ARCHIVE_FILENAME."
    # Remove the archive after extraction
    echo "  [>] Removing downloaded archive $ARCHIVE_FILENAME..."
    rm "$ARCHIVE_FILENAME"
else
    echo "Error: Failed to extract $ARCHIVE_FILENAME. Please ensure 'tar' is installed and the archive is valid. Exiting."
    exit 1
fi
echo ""

# --- Step 5: Ask user about unpacking raw data ---
echo "[?] The mcsee-data archive has been extracted. Do you want to unpack the raw data? (y/N)"
read -r -p "" UNPACK_RAW_DATA
UNPACK_RAW_DATA=${UNPACK_RAW_DATA,,} # Convert to lowercase

if [[ "$UNPACK_RAW_DATA" == "y" ]]; then
    echo "[>] User chose to unpack raw data."

    # Check if prepare_data.sh exists in the mcsee-data directory
    if [ -f "$DATA_DIR/prepare_data.sh" ]; then
        echo "[>] Changing directory to $DATA_DIR to run prepare_data.sh"
        pushd "$DATA_DIR" > /dev/null || { echo "Error: Could not navigate into $DATA_DIR. Exiting."; exit 1; }

        echo "[>] Making prepare_data.sh executable..."
        chmod +x prepare_data.sh
        if [ $? -eq 0 ]; then
            echo "[>] Executing prepare_data.sh --decompress..."
            ./prepare_data.sh --decompress
            if [ $? -eq 0 ]; then
                echo "[>] Raw data unpacked successfully."
            else
                echo "Error: prepare_data.sh --decompress failed. Check its output for details."
            fi
        else
            echo "Error: Failed to make prepare_data.sh executable."
        fi
        popd > /dev/null # Return to the original directory
    else
        echo "Warning: prepare_data.sh not found in $DATA_DIR. Skipping raw data unpacking."
    fi
else
    echo "[>] User chose NOT to unpack raw data."
fi
echo ""

echo "[>] Setup complete!"
echo "[>] Your workspace is ready in: $(pwd)"
echo "[>] Displaying workspace structure (2 levels deep):"
# Ensure 'tree' command is available in your system. If not, install it (e.g., 'sudo apt install tree' on Debian/Ubuntu).
tree -L 2
echo ""
