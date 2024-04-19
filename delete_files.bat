@echo off
setlocal

:: Set your Google Cloud Storage bucket, folder path, and extension
set BUCKET_NAME=your_bucket_name
set FOLDER_PATH=your_folder_path
set EXTENSION=extension

:: List files with the specified extension and delete each file
for /f "delims=" %%f in ('gsutil ls gs://%BUCKET_NAME%/%FOLDER_PATH%/*.%EXTENSION%') do (
    gsutil rm "%%f"
)

echo Files with extension %EXTENSION% deleted from Google Cloud Storage bucket %BUCKET_NAME% in folder %FOLDER_PATH%

endlocal
