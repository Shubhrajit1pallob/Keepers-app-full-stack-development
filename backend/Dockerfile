FROM python:3.12-slim

WORKDIR /app

RUN apt-get update && apt-get install -y \
    netcat-openbsd \
    && rm -rf /var/lib/apt/lists/*

COPY requirements.txt ./
RUN pip install --no-cache-dir -r requirements.txt

COPY . .

ENV FLASK_APP=run.py
ENV FLASK_ENV=production
ENV PYTHONUNBUFFERED=1

EXPOSE 8888

CMD ["gunicorn", "--bind", "0.0.0.0:8888", "--workers", "3", "--timeout", "120", "run:app"]