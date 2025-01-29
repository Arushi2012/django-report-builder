FROM python:3.8

ENV PYTHONUNBUFFERED=1
ENV POETRY_VERSION=1.8.5
ENV POETRY_VIRTUALENVS_CREATE=false
ENV PIP_DISABLE_PIP_VERSION_CHECK=on

WORKDIR /code

# Install system-level dependencies
RUN apt-get update && apt-get install -y --no-install-recommends curl gcc make

# Upgrade pip and related tools to their latest version
RUN pip install --upgrade pip setuptools wheel virtualenv

# Reinstall specific version of Poetry and upgrade poetry-core
RUN curl -sSL https://install.python-poetry.org | python3 -
RUN pip install --upgrade poetry-core

# Consider manually allowing Poetry's virtual environment creation
RUN poetry config virtualenvs.create true

# Copy project descriptors and prepare to install dependencies
COPY poetry.lock pyproject.toml /code/

# Execute install verbose to capture thorough debug output if needed
RUN poetry install --no-interaction --no-ansi --no-root -vvv

# Copy application source after dependency setup
ADD . /code/
