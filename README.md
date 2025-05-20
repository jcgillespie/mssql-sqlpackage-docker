# Welcome

This image adds the `sqlpackage` CLI to the Microsoft SQL Server image. It is useful for deploying `.dacpac` files to SQL Server Linux containers.

# Usage

After getting your `.dacpac` into your container instance, you can connect and use `sqlpackage` to deploy to SQL Server. For example, given a file named `myDB.dacpac` in the `tmp` folder,

`/opt/sqlpackage/sqlpackage /a:Publish /tsn:. /tdn:"MyDBName" /tu:<user> /tp:"<password>" /sf:/tmp/myDB.dacpac`

This can also be used as a component in a multi-stage Docker build. For example,

```
FROM jcgillespie/mssql-sqlpackage AS SqlBuilder
ARG DB_NAME
ARG ACCEPT_EULA
ARG SA_PASSWORD
ENV ACCEPT_EULA=${ACCEPT_EULA}
ENV SA_PASSWORD=${SA_PASSWORD}

COPY myDB.dacpac /tmp/db.dacpac
RUN ( /opt/mssql/bin/sqlservr & ) | grep -q "Service Broker manager has started" \
    && /opt/sqlpackage/sqlpackage /a:Publish /tsn:. /tdn:"${DB_NAME}" /tu:sa /tp:"${SA_PASSWORD}" /sf:/tmp/db.dacpac \
    && rm /tmp/db.dacpac \
    && pkill sqlservr

# Create the final image
FROM mcr.microsoft.com/mssql/server:2025-latest
COPY --from=SqlBuilder /var/opt/mssql/data/* /var/opt/mssql/data/
USER root
RUN chown -R mssql /var/opt/mssql/data
USER mssql
```

# License

MIT
