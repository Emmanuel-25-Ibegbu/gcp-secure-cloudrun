FROM python:3.12-slim

ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1

WORKDIR /app

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY main.py .

# Run as a non-root user
RUN useradd --create-home --uid 10001 appuser
USER appuser

CMD exec gunicorn --bind :$PORT --workers 1 --threads 8 --timeout 0 main:app
