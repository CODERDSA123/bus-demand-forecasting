data:
	python -m src.generate_data
	python -m src.data_quality
	python -m src.split

train:
	python -m src.train

evaluate:
	python -m src.evaluate
	python -m src.explain

api:
	uvicorn api.main:app --reload

app:
	streamlit run app/streamlit_app.py

test:
	pytest -q

all: data train evaluate test
