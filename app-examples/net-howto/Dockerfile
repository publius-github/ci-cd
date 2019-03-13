FROM microsoft/dotnet:2.2-sdk as build

ARG GO_PIPELINE_COUNTER
ARG GO_STAGE_COUNTER

WORKDIR /build

COPY . /build

RUN bash ./run_build.sh

# -----------------

FROM microsoft/dotnet:2.2-aspnetcore-runtime

COPY --from=build --chown=nobody:nogroup ./build/src/Travel.EnquiryPresenter/bin/Release/netcoreapp2.2/publish ./app

USER nobody

WORKDIR /app

EXPOSE 9000

CMD ["dotnet", "Travel.EnquiryPresenter.dll"]