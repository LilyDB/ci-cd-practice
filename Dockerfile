FROM python:3.11-slim

WORKDIR /app

COPY requirements.txt .
RUN pip install -r requirements.txt

COPY *.py .

EXPOSE 8001

CMD ["python", "app.py"]