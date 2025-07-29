FROM python:3.13-alpine

#Install uv.
COPY --from=ghcr.io/astral-sh/uv:latest /uv /uvx /bin/

WORKDIR /app
RUN apt update && apt install -y git
RUN --mount=type=cache,target=/root/.cache/uv \
    --mount=type=bind,source=uv.lock,target=uv.lock \
    --mount=type=bind,source=pyproject.toml,target=pyproject.toml \
    uv sync --locked --no-install-project

ADD . /app

RUN --mount=type=cache,target=/root/.cache/uv \
    uv sync --locked

CMD ["uv", "run", "streamlit", "run", "main.py"]