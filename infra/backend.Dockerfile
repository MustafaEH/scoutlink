FROM python:3.12-slim

ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    UV_COMPILE_BYTECODE=1 \
    UV_LINK_MODE=copy
WORKDIR /app
RUN pip install --no-cache-dir uv==0.12.7
COPY pyproject.toml uv.lock ./
COPY apps/api ./apps/api
COPY apps/worker ./apps/worker
RUN uv sync --frozen --no-dev --all-packages
ENV PATH="/app/.venv/bin:$PATH"
EXPOSE 8000
CMD ["uvicorn", "scoutlink_api.main:app", "--host", "0.0.0.0", "--port", "8000"]
