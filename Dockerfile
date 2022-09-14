# For more information, please refer to https://aka.ms/vscode-docker-python
FROM python:3.8-slim

# The FROM instruction must be the first instruction in any Dockerfile. It sets a base Docker image from which to create the new image.  

EXPOSE 8000
# The EXPOSE instruction acts as documentation for the port that will be used by the Docker container. 

# Keeps Python from generating .pyc files in the container
ENV PYTHONDONTWRITEBYTECODE=1

# Turns off buffering for easier container logging
ENV PYTHONUNBUFFERED=1

# Install pip requirements
COPY requirements.txt .
RUN python -m pip install -r requirements.txt

# The COPY instruction  copies files from a source into the Docker image's filesystem. In this case, the requirements.txt file that contains this application's Python package dependencies is being copied into the home folder of the image.
# The RUN instruction will run a command in the Docker image, which automatically creates a new image layer. 

WORKDIR /app
# The WORKDIR instruction sets the working directory within the image's filesystem for instructions that follow it, meaning those instructions will be executed from in that directory/folder.
COPY . /app
# The COPY instruction takes two arguments: a source to copy from, and a destination to copy to. The dot represnts the current folder in the comptuer's filesystem where the Docerfile exists. /app is where the copy will be saved.

# Creates a non-root user with an explicit UID and adds permission to access the /app folder
# For more info, please refer to https://aka.ms/vscode-docker-python-configure-containers
RUN adduser -u 5678 --disabled-password --gecos "" appuser && chown -R appuser /app
USER appuser
#	This RUN instruction creates a new user in the Docker image environment. 
#  The USER instruction sets that newly created user as the one to use when the image is run.


# During debugging, this entry point will be overridden. For more information, please refer to https://aka.ms/vscode-docker-python-debug
CMD ["gunicorn", "--bind", "0.0.0.0:8000", "hello_django.wsgi"]

# 	The CMD instruction in general is used to specify a command to run when an image is actually run, along with any arguments for it, provided in the form of a JSON array. 
# 	Unlike other instructions, this is not an instruction that occurs when the image is being built, but saved for when the image is run after being built. -- There can only be one CMD per image.
