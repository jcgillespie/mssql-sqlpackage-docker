FROM alpine:3.21.3 AS Unzipper
RUN apk add --no-cache unzip wget
# Install SQLPackage for Linux and make it executable
RUN wget -progress=bar:force -q -O sqlpackage.zip https://aka.ms/sqlpackage-linux \
    && unzip -qq sqlpackage.zip -d /sqlpackage \
    && chmod +x /sqlpackage/sqlpackage

FROM mcr.microsoft.com/mssql/server:2025-latest
COPY --from=Unzipper  /sqlpackage/ /opt/sqlpackage/
CMD [ "/opt/mssql/bin/sqlservr" ]
