basepath = "~/Library/Application\ Support/Autodesk/webdeploy/production/"

suffix =
  "Autodesk\ Fusion\ 360.app/Contents/Libraries/Applications/Fusion/Fusion/Server/Fusion/Configuration/ThreadData"

expanded = Path.expand(basepath)

{:ok, dirs} = File.ls(expanded)

app_dirs = Enum.filter(dirs, &(String.length(&1) == 40))

source_path = Path.expand("./threads")

source_files =
  with {:ok, files} <- File.ls(source_path),
       xml_files <- Enum.filter(files, &String.ends_with?(&1, ".xml")) do
    Enum.map(xml_files, &Path.join(source_path, &1))
  end

for dir <- app_dirs do
  rp = Path.join(expanded, dir)
  target_dir = Path.join(rp, suffix)

  if File.dir?(target_dir) do
    for source_file <- source_files do
      File.cp(source_file, Path.join(target_dir, Path.basename(source_file)))
    end
  end
end
