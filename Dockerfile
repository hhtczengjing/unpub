FROM google/dart

WORKDIR /app
COPY ./unpub ./
RUN dart pub get
ENTRYPOINT ["dart", "run", "bin/unpub.dart", "--database", "mongodb://mongo:27017/dart_pub"]