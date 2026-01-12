#!/bin/bash

set -e

VERSION=${1:-"0.0.0"}
ADDON_NAME="GroupActivityFinderExtensions"
DIST_DIR="./dist"
BUILD_DIR="${DIST_DIR}/${ADDON_NAME}"
OUTPUT_ZIP="${ADDON_NAME}_${VERSION}.zip"

FILES_TO_COPY=(
    "${ADDON_NAME}.addon"
    "LICENSE"
    "src/**/*"
)

echo "Creating temporary directory: ${BUILD_DIR}"
mkdir -p "${BUILD_DIR}"

ADDON_FILE="${ADDON_NAME}.addon"
echo "Updating version to ${VERSION} in ${ADDON_FILE}"
sed -i.bak "s/^## Version:.*$/## Version: ${VERSION}/" "$ADDON_FILE"
rm -f "${ADDON_FILE}.bak"  # Remove backup file

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

            mkdir -p "${BUILD_DIR}/${file_dir}"

            echo "  Copying: $file"
            cp "$file" "${BUILD_DIR}/${file}"
        elif [ -d "$file" ]; then
            echo "  Skipping directory: $file"
        fi
    done
done

shopt -u globstar nullglob

# Create zip archive
echo "Creating zip archive: ${OUTPUT_ZIP}"
cd "${DIST_DIR}"
zip -r "${OUTPUT_ZIP}" "${ADDON_NAME}"

echo "Archive created successfully: ${DIST_DIR}/${OUTPUT_ZIP}"

echo "Done!"
