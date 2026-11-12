# Bus Passenger-Demand Forecasting

This MVP forecasts booked passengers for one scheduled intercity bus departure. The decision is whether a planner should add a bus, use a larger bus, retain the plan, or consider merging a low-demand departure. The prediction unit is route plus departure datetime, the target is `passenger_count`, and the forecast is made seven days before departure at 00:00.

## Folder structure

`src/` contains generation, quality, features, splitting, training, evaluation, explanation, and inference. `api/` contains FastAPI contracts and endpoints. `app/` contains the Streamlit planner interface. `data/` contains generated and processed data. `artifacts/` contains models, metrics, plots, feature lists, and explanations. `docs/` contains the technical report and architecture.

## Environment setup

Windows PowerShell:

```powershell
python -m venv .venv
.venv\Scripts\python.exe -m pip install -r requirements.txt
```

## Reproduce the pipeline

```powershell
.venv\Scripts\python.exe -m src.generate_data
.venv\Scripts\python.exe -m src.data_quality
.venv\Scripts\python.exe -m src.split
.venv\Scripts\python.exe -m src.train
.venv\Scripts\python.exe -m src.evaluate
.venv\Scripts\python.exe -m src.explain
.venv\Scripts\python.exe -m pytest -q
```

Run the API and app:

```powershell
.venv\Scripts\python.exe -m uvicorn api.main:app --host 127.0.0.1 --port 8001 --reload
.venv\Scripts\python.exe -m streamlit run app/streamlit_app.py
```

## Sample API request

```powershell
Invoke-RestMethod -Method Post -Uri http://localhost:8000/predict -ContentType "application/json" -Body '{"route_id":"R01","departure_datetime":"2024-12-15T08:00:00","bus_capacity":55,"fare":485,"origin":"Chandigarh","destination":"Delhi","distance_km":245}'
```

## Results

The generated `artifacts/metrics.json` contains validation and test MAE, RMSE, WAPE, interval coverage, capacity-flag accuracy, and improvement versus baseline. `artifacts/model_comparison.csv` contains the baseline and every candidate model.

## Limitations

Demand is capped at bus capacity, so observed bookings are censored and full buses may hide unmet demand. The data is synthetic and is not equivalent to real passenger behaviour. New routes are cold starts, disruption days may not resemble future disruptions, and unusual events can cause large errors. The model is decision support only and every recommendation requires human planner review.

