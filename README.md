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

note the use of \ to escape whitespace character
