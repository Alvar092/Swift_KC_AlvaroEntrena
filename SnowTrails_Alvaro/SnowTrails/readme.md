## :snowflake:**Snowtrails!**:snowflake:

###*¿Que es Snowtrails?*

Snowtrails es una aplicación que surge como respuesta a la llamada de la naturaleza que todos los esquiadores albergamos en nuestro interior. 

Mediante un moderno sistema de geolocalización, los diferentes puntos de interes en la montaña estarán mas accesibles que nunca. 

Elige una de las rutas preestablecidas que se han creado mediante nuestro algoritmo o explora nuevos itinerarios obteniendo la opción mas corta entre dos puntos.

### *¿Cómo funciona Snowtrails?*
Al iniciar la aplicación encontrarás un menú con las siguientes opciones:
1- Acceder como usuario
2- Acceder como administrador
3- Log out

A continuación veamos que ofrecen los diferentes menús:
1- Acceder como usuario
    1- Ver todas las rutas: Aqui se mostrarán todas las rutas preestablecidas con su longitud. 
    2- Obtener la ruta mas corta entre dos puntos: Actualmente en construcción, estad atentos a futuras actualizaciones!
    3- Log out: para volver al menú principal. 


2- Acceder como administrador: 
    1- Ver todos los usuarios.
    2- Añadir un usuario nuevo. 
    3- Eliminar un usuario.
    4- Añadir punto a una ruta: Actualmente en construcción, estad atentos a futuras actualizaciones! 
    5-Log out: para volver al menu principal. 

3- Log out: cierra la aplicación inmediatamente.



### *Especificaciones concretas del proyecto*

El proyecto se ha organizado con los siguientes archivos:
- DataSource: base de datos con la información de los picos, sus puntos de localización, conexiones y rutas preestablecidas. El acceso a esta base de datos se ha creado a través de un patrón Singleton. Se ha creado la clase TopographicDataSource y se ha declarado una única instancia de acceso, garantizando un punto de acceso global. 

Tanto los puntos topográficos como las rutas se han gestionado usando arrays como estructura de datos. 


- Logger: Se ha creado una clase AppLogger que se adhiere a un protocolo Logging. Dicho protocolo tiene dos funciones que registran los mensajes de error y de info así como su destinatario (usuario o desarrollador). Tanto a MenuController como a Programm se les ha creado una propiedad del Logger que es de tipo Logging. 

- Menucontroller: La clase MenuController gestiona todo lo relacionado con mostrar lineas de comando en consola y permitir navegar por los diversos menus, así como solicitar los servicios pertinentes a Programm en función de la navegación. 

- Programm: En este Struct se recogen todas las funcionalidades que el programa necesita para el funcionamiento de los servicios que ofrece. Se ha diferenciado entre funciones que recogen el input del usuario y funciones que realizan operaciones, pudiendo recoger algunas el input del usuario a traves de las otras funciones. 

- Users: Se ha establecido el rol del usuario en base a un Enum y se ha creado un array de Users para establecer un registro de usuarios. 


### *Puntos completados del proyecto*


2. Funcionalidades obligatorias 
    2.1 Menu de login
    2.2 Menu de usuario normal:
        2.2.1 Visualización de rutas
        2.2.2 Obtener ruta mas corta 
        2.2.3 Log out 
    2.3 Menu de administrador: 
        2.3.1 Mostrar usuarios
        2.3.2 Añadir usuario 
        2.3.3 Eliminar usuario 
        2.3.4 Añadir punto a una ruta
        2.3.5 Logout

3. Funcionalidades complementarias:
    3.1 Menu login
    3.2 Menu de usuario normal 
        3.2.1 Obtener ruta mas corta  
    3.3 Menu de administrador 
        3.3.1 Añadir usuario 
        3.3.2 Añadir punto a una ruta 


- Logs para desarrollador y usuario implementados. 


### *Dificultades y comentarios* 

- El patrón Singleton tiene sus ventajas e inconvenientes. Ha sido sencillo por la parte de poder acceder como una variable global a las estructuras de datos, pero ha sido un verdadero dolor testar con este patrón. 

- El punto 2.2.2 Obtener ruta mas corta parece que funciona, pero al comprobar con el ejemplo del enunciado he encontrado una ruta algo mas corta, por lo que tengo serias dudas sobre que este bien... pero no me da tiempo de hacerle testing.

- Agradecimientos a Isma y compañeros, por el apoyo que brindan y la pequeña comunidad que ha sido este módulo para ir todos juntos progresando. 

