# Deep Learning

Proyectos desarrollados durante el modulo de redes neuronales y modelos avanzados. La seleccion esta curada para mostrar redes feedforward, regularizacion, busqueda de hiperparametros, CNN y RNN/NLP sin subir artefactos pesados.

## Subproyectos

| Proyecto | Tecnicas principales | Archivo principal |
| --- | --- | --- |
| Customer Churn FFNN | red neuronal feedforward, clasificacion, metricas | `01-customer-churn-ffnn/customer_churn_neural_network.ipynb` |
| Hotel Booking FFNN | red neuronal feedforward, regularizacion, Grid Search, SciKeras | `02-hotel-booking-ffnn/hotel_booking_cancellation_neural_network.ipynb` |
| Natural Scenes CNN | redes convolucionales, clasificacion de imagenes | `03-natural-scenes-cnn/natural_scenes_cnn.ipynb` |
| Movie Reviews RNN | procesamiento de texto, embeddings, red recurrente | `04-movie-reviews-rnn/movie_reviews_rnn.ipynb` |

## Nota sobre datasets pesados

Los proyectos CNN y RNN no incluyen datasets ni embeddings pesados. En el material original existian archivos `.npy`, `.bin`, `.keras` y datasets grandes que no son adecuados para GitHub. Se conserva el notebook para evidenciar arquitectura, flujo de trabajo, entrenamiento y evaluacion.
