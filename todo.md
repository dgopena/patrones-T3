Lectura de imagenes
===================

  * Tramite del codigo de lectura desde el dataset y lectura del archivo ground truth. Simplemente extraer los datos desde los archivos a el programa.
  * A medida que se lee, resize las imagenes a no mas de 640 pixeles (manteniendo proporcion).
  * Tras cargar dataset, guardar el program state en un .mat

  Con imagemagick (y parallel) se puede hacer un shrink de las imágenes así:
```sh
time find Datasets/oxbuild_images/ -name "*jpg" | parallel 'mogrify -resize 640x640  {}'
```
  Así no hay que tener todo cargado en memoria al procesar el dataset.


Extracción de descriptores
==========================

  * Extraer descriptores SIFT de las imagenes del dataset, no contando las 55 de consulta, usando Difference of Gaussians (DoG)
    - 1000 descriptores por imagen
    - [Vlfeat en Matlab](http://www.vlfeat.org/install-matlab.html)
    - [Documentacion](http://www.vlfeat.org/matlab/matlab.html)
    - [SIFT en vlfeat](http://www.vlfeat.org/overview/sift.html)
    - Ojala sacar output del SIFT match que logra vlfeat para usarlo en el informe

  * Armar 3 codebook usando k-means
    - 100k random descriptors
    - 64, 128 y 256 clusters respectivamente
    - [k-means en Matlab](http://www.mathworks.com/help/stats/kmeans.html)



VLAD
====

   * Aplicar VLAD segun el metodo del paper [2] Aggregating Local Image Descriptors into Compact Codes" (por leer)


Ranking
-------

  * Ordenar ranking de del dataset respecto a una consulta usando distancia Euclidiana y Hellinger (creo que tengo los metodos por alguna parte ya hechos, buscare).
    - Recordar que solo hay dos etiquetas: Good y Bad.
  * Calcular:
    - Precisión promedio por consulta
    - Precisión media del metodo en todas las consultas
    - Graficar resultados en grafico Precision-Recall (para cada uno de los 3 clusters)


