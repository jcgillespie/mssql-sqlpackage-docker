FROM alpine:3.13.0 AS Unzipper
RUN apk add --no-cache unzip wget
# Install SQLPackage for Linux and make it executable
RUN wget -progress=bar:force -q -O sqlpackage.zip https://go.microsoft.com/fwlink/?linkid=2087431 \
    && unzip -qq sqlpackage.zip -d /sqlpackage \
    && chmod +x /sqlpackage/sqlpackage

FROM mcr.microsoft.com/mssql/server:2019-latest
COPY --from=Unzipper  /sqlpackage/ /opt/sqlpackage/
CMD [ "/opt/mssql/bin/sqlservr" ]