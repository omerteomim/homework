FROM python:3.11-slim

RUN pip install flask requests

WORKDIR /app

COPY . .

EXPOSE 80

CMD ["python", "app.py"]
