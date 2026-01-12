#!/bin/bash

set -e

VERSION=${1:-"0.0.0"}
ADDON_NAME="GroupActivityFinderExtensions"
DIST_DIR="./dist"
TEMP_DIR="${DIST_DIR}/tmp/${ADDON_NAME}"
OUTPUT_ZIP="${DIST_DIR}/GroupActivityFinderExtensions_${VERSION}.zip"

FILES_TO_COPY=(
    "${ADDON_NAME}.addon"
    "LICENSE"
    "src/**/*"
)

echo "Creating temporary directory: ${TEMP_DIR}"
mkdir -p "${TEMP_DIR}"

if [ -f "$ADDON_FILE" ]; then
    echo "Updating version to ${VERSION} in ${ADDON_FILE}"
    sed -i.bak "s/^## Version:.*$/## Version: ${VERSION}/" "$ADDON_FILE"
    rm -f "${ADDON_FILE}.bak"  # Remove backup file
else
    echo "Warning: ${ADDON_FILE} not found, skipping version update"
fi

echo "Copying files..."
shopt -s globstar nullglob

for pattern in "${FILES_TO_COPY[@]}"; do
    files=($pattern)

    if [ ${#files[@]} -eq 0 ]; then
        echo "  Warning: No files matched pattern - $pattern"
        continue
    fi

    for file in "${files[@]}"; do
        if [ -f "$file" ]; then
            file_dir=$(dirname "$file")

            mkdir -p "${TEMP_DIR}/${file_dir}"

            echo "  Copying: $file"
            cp "$file" "${TEMP_DIR}/${file}"
        elif [ -d "$file" ]; then
            echo "  Skipping directory: $file"
        fi
    done
done

shopt -u globstar nullglob

# Create zip archive
echo "Creating zip archive: ${OUTPUT_ZIP}"
zip -r "${OUTPUT_ZIP}" "${TEMP_DIR}"
cd - > /dev/null

echo "Archive created successfully: ${DIST_DIR}/${OUTPUT_ZIP}"

echo "Done!"
