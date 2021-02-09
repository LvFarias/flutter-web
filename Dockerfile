FROM ubuntu:20.04
WORKDIR /
ENV DEBIAN_FRONTEND=noninteractive 
RUN apt update
RUN apt -y install git wget curl unzip lcov lib32stdc++6 libglu1-mesa default-jdk-headless python3
ENV ANDROID_VERSION=30
ENV ANDROID_SDK_VERSION=6200805
ENV ANDROID_HOME=/opt/android_sdk
ENV ANDROID_SDK_ARCHIVE=${ANDROID_HOME}/archive
ENV ANDROID_SDK_URL=https://dl.google.com/android/repository/commandlinetools-linux-${ANDROID_SDK_VERSION}_latest.zip
RUN mkdir -p "${ANDROID_HOME}"
RUN wget -q "${ANDROID_SDK_URL}" -O "${ANDROID_SDK_ARCHIVE}"
RUN unzip -q -d "${ANDROID_HOME}" "${ANDROID_SDK_ARCHIVE}"
RUN yes "y" | "${ANDROID_HOME}/tools/bin/sdkmanager" --sdk_root=${ANDROID_HOME} "build-tools;$ANDROID_VERSION.0.0"
RUN yes "y" | "${ANDROID_HOME}/tools/bin/sdkmanager" --sdk_root=${ANDROID_HOME} "platforms;android-$ANDROID_VERSION"
RUN yes "y" | "${ANDROID_HOME}/tools/bin/sdkmanager" --sdk_root=${ANDROID_HOME} "platform-tools"
RUN rm "${ANDROID_SDK_ARCHIVE}"
ENV FLUTTER_ROOT=/opt/flutter
ENV FLUTTER_VERSION=1.26.0-12.0.pre
RUN git clone --branch $FLUTTER_VERSION https://github.com/flutter/flutter.git "${FLUTTER_ROOT}"
ENV PATH=${ANDROID_HOME}/tools:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
ENV PATH=${ANDROID_HOME}/tools/bin:${PATH}
ENV PATH=${FLUTTER_ROOT}/bin:${PATH}
RUN flutter config --enable-web
RUN flutter config --no-analytics
RUN flutter precache
RUN yes "y" | flutter doctor --android-licenses
RUN flutter doctor -v
WORKDIR /usr/local/bin/app
ENV SERVER_UP=/usr/local/bin/server/server.sh
COPY ./server.sh ${SERVER_UP}
RUN chmod +x ${SERVER_UP}
ENV PORT=8080
EXPOSE ${PORT}
ENTRYPOINT [ "/usr/local/bin/server/server.sh" ]