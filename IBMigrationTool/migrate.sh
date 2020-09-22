
bin_path="IBMigrationTool"
migrationtool_binary_download_url="https://raw.githubusercontent.com/3sidedcube/ThunderBasics/feature/migration_tool_improvements/IBMigrationTool/IBMigrationTool"

echo " => Downloading IBMigrationTool from (${migrationtool_binary_download_url})

curl -fL --progress-bar --output "IBMigrationTool" "$migrationtool_binary_download_url"

echo " => Making it executable ..."
chmod +x "${bin_path}"

sh ${bin_path}
