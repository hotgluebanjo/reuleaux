if ($args.length -eq 0) {
    exit
}

$version = $args[0]
$archive_dir = "release"

if (test-path $archive_dir) {
    rm -r -fo $archive_dir
}
md $archive_dir | out-null

function zip-reuleaux($source_dir, $file_match) {
    $tmp_dir = "$archive_dir/tmp_$source_dir"
    cp -r $source_dir $tmp_dir
    foreach ($file in (dir -r -n $tmp_dir) -notmatch $file_match -match '.*\..*') {
        rm "$tmp_dir/$file"
    }
    compress-archive "$tmp_dir/*" "$archive_dir/reuleaux-$version-$source_dir.zip"
    rm -r -fo $tmp_dir
}

zip-reuleaux resolve '\.dctl'
zip-reuleaux nuke '\.(blink|nk)'
