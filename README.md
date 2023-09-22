# Patients REST API Service
## THVC Take-home assignment

### Description
This repo is a basic ruby api server that serves several endpoints. As an engineer, you've been tasked with expanding upon our `/patients` endpoint in several ways - noted below. The exercise is designed to take ~1-2 hours.

### Tech Stack
- ruby (3.2.2)
- postgres (using the 'pg' gem)
- redis
- sinatra (3.1.0)
- docker

### Project Overview
The project is quite simple, but a few notes:
- You will need to restart your docker container to see changes.
- Your code changes only need to be done in the `/lib` directory.
- The `/lib/rest.rb` file is responsible for requiring all files found in the `/lib/rest` directory, and mounting the endpoints. As long as new files are a direct child of the `/lib/rest` directory, following the convention in the provided examples, you should not have to do anything else beyond that.
- Several util modules and classes exist. Feel free to extend them, modify them, or remove them as you see fit.
- Please do not add any additional libraries to the project. Everything you need has already been made available to you in this repo.

### Requirements
1. In the `/lib/vandelay/rest/patients_patient.rb` file, add a new endpoint that retrieves a single patient from the db, and responds with it. Errors are expected to be accounted for and handled appropriately.

2. We've been asked to implement integrations with two external apis for vendor apis that serve patient records. They have different specs, and we need a way to intechangeably fetch records from them based on 2 columns in the `patients` table - `records_vendor` and `vendor_id`. `records_vendor` is an identifier for which integration to fetch the patient records from, and `vendor_id` is the patient's record id in that vendor's system. You are expected to implement the code in the `/lib/vandelay/services/patient_records.rb` file to fetch patient records for a given `patient` object, based on the patient data. The integration code may be added where you see fit, however the `/lib/vandelay/integrations` directory has been provided for you if you wish to use it. The patient records should be retrievable by a new API endpoint `/patients/:patient_id/record` - you will need to add this in an appropriate place in the code.

- Connection urls for both integration vendors can be found in the `config.yml` file in the repo root.
- Both vendor apis require authentication (we've faked this process for this assignment, but the implementation is expected in the integrations) - vendor-specific details below
- The integration classes should implement the same interface.
- The `PatientRecords` service should be able to fetch records from the correct `vendor` based on patient data.

Vendor One API Specs:
- endpoints:
  - GET /auth/1 -> returns a payload with a token id - the api is mocked, so there is no POST
  - GET /patients -> returns all patients
    - GET /:id -> returns a specific patient with that id

Vendor Two API Specs:
- endpoints:
  - GET /auth_tokens/1 -> returns a payload with a token id - the api is mocked, so there is no POST
  - GET /records -> returns all patient records
    - GET /:id -> returns a specific patient record with that id

Authentication:
- The auth token should be fetched in each integration, and passed as an `Authorization` header to all subsequent requests using the following formatting: `Bearer <token goes here>`

*Note:*
> We are only interested in the following pieces of data from the vendor's patient records:
> - province
> - allergies
> - number of recent medical visits
>
> *Please ensure only this data is returned from the vendor integrations.*


3. The patient records retrieved from the vendors does not change frequently, and we've been asked to improve performance when fetching the records through the `PatientRecords`. Implement a caching strategy that will reduce the overhead of network requests for patient records. Keep in mind that the data is acceptably stale up to 10 minutes, but should be refetched again in order to maintain (mostly) reliable data accuracy.

### Getting Started
For ease of setup, we've dockerized this project to avoid installation and setup of different dependencies. However, you are required to have `docker` installed. If you haven't installed `docker`, please install it now.

Once you have `docker` installed. You may clone this repo, and navigate to it in your preferred terminal.

Once in this repo's directory, simply run:

```bash
docker compose up -d
```

This should start all the servers required up, and initialize the project. You will be able to test the API at the following url:
```
http://localhost:3087
```

### Making changes
1. Fork this repo, clone it, and branch off of the `main` branch of your newly cloned fork. Please name it with the following convention:
```
<your initials>/interview/ruby-take-home
```

2. Commit your work as you would on any other project.

3. Writing tests is not required for this assignment. You may focus on the requirements above.

4. When you are complete your work, push your work up to your github, open a PR against the `main` branch, and send us the link. Please label the PR the same as your branch name, and write a PR description that will help us best assess your work. This is your chance to point out where you had problems, what you would have done better, or give context to decisions in your work that was not already commented on in code comments.

5. Once your PR is opened, we will review it and respond to you as soon as we can.
