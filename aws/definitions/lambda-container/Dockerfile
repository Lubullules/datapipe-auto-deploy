FROM public.ecr.aws/lambda/python:3.13

COPY ../processRedditData.py requirements.txt ${LAMBDA_TASK_ROOT}/
RUN pip install --no-cache-dir -r requirements.txt

CMD ["processRedditData.lambda_handler"]