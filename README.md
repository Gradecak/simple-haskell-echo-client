# CS4032 Lab 1 - Echo Client
To run navigate to project folder and execute following 

```bash
stack build
stack exec echoClient <remote address> <port> <remote resource> <paramater>
```

example 

```bash
stack exec echoClient localhost 8000 /echo.php message=test\ message
```

__note the use of \ to escape whitespace character__

This client has been tested with the supplied echo.php server which can be found in the root directory of this project


to run server navigate to where the echo.php file is located and execute
```bash
php -S localhost:8000 -t .
```
