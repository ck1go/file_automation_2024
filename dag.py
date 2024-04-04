from datetime import datetime
from airflow import DAG
from airflow.contrib.operators.gcs_delete_operator import GoogleCloudStorageDeleteOperator
from airflow.operators.dummy_operator import DummyOperator

default_args = {
    'owner': 'airflow',
    'depends_on_past': False,
    'start_date': datetime(2024, 4, 5),
    'email_on_failure': False,
    'email_on_retry': False,
    'retries': 1,
    'retry_delay': timedelta(minutes=5),
}

dag = DAG(
    'delete_files_from_gcs',
    default_args=default_args,
    description='A DAG to delete files from GCS bucket based on selected date',
    schedule_interval='@once',  # You can adjust the schedule interval as per your requirement
)

start_task = DummyOperator(task_id='start_task', dag=dag)

delete_files_task = GoogleCloudStorageDeleteOperator(
    task_id='delete_files_task',
    bucket='your-gcs-bucket-name',
    prefix='your/gcs/path/{{ execution_date.strftime("%Y%m%d") }}',  # Use execution_date to dynamically select date
    delegate_to=None,  # Service account to be used. Set to None for default credentials.
    dag=dag,
)

end_task = DummyOperator(task_id='end_task', dag=dag)

start_task >> delete_files_task >> end_task
