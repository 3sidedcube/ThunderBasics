
bin_path="IBMigrationTool"
migrationtool_binary_download_url="https://raw.githubusercontent.com/3sidedcube/ThunderBasics/develop/IBMigrationTool/IBMigrationTool"

echo "=> Downloading IBMigrationTool from (${migrationtool_binary_download_url})"

curl -fL --progress-bar --output "IBMigrationTool" "${migrationtool_binary_download_url}"

echo "=> Making it executable ..."
chmod +x "${bin_path}"

./${bin_path}

rm -rf ${bin_path}
