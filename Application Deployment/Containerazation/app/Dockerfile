# Stage 1: builder
FROM python:3.11-slim AS builder
WORKDIR /app
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1
COPY requirements.txt .
RUN apt-get update \
&& apt-get install -y build-essential libpq-dev --no-install-recommends \
&& pip install --upgrade pip \
&& pip install --prefix=/install -r requirements.txt \
&& rm -rf /var/lib/apt/lists/*


# Stage 2: runtime
FROM python:3.11-slim
WORKDIR /app
ENV PATH=/install/bin:$PATH
COPY --from=builder /install /install
COPY src/ /app
RUN useradd --no-create-home --shell /bin/false appuser \
&& chown -R appuser:appuser /app \
&& chmod -R 755 /app
USER appuser
EXPOSE 5000
CMD ["python", "app.py"]