# myfortran
My experiments using Fortran

## Developement Docker File: fortran-dev

### Build

cd to docker and run the following build command to create a
conntainer tagged 'fortran-dev':

```bash
docker build --tag fortran-dev fortran-dev
```

Expected Error message on docker build when starting nvim before installing
required Plugins.

```
Error detected while processing /home/baudekin/.config/nvim/init.vim:
line   84:
E185: Cannot find color scheme 'desert-warm-256'Error detected while processing function <SNR>2_install[1]..<SNR>2_update_impl[113]..<SNR>2_update_vim[4]..<SNR>2_tick:
line   17:
E117: Unknown function: coc#status
E15: Invalid expression: coc#status()remote/host: python3 host registered plugins []
remote/host: generated rplugin manifest: /home/baudekin/.local/share/nvim/rplugin.vimRemoving intermediate container f80b8b8846e9
```

### Run

1. Create a new volume which can be reused in subscant runs.
```bash
docker volume create baudekin_home
```

1. Run the container:
```bash
docker run --name fortran-dev --mount source=baudekin_home,target=/home/baudekin -it --rm fortran-dev
```

### Access the container

* Copy files to fortran-dev:
```bash
docker cp Makefile fortran-dev:/home/baudekin/
```
* Copy from fortran-dev:
```bash
docker cp fortran-dev:/home/baudekin/hello.f90 .
```

