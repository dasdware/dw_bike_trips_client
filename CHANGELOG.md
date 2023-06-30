# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

Nothing yet!

## [0.10.0]

### Added

- Allow for optional time portion in trip timestamps ([#16](https://github.com/dasdware/dw_bike_trips_client/issues/16)). Old entries that have been added with midnight as time portion are considered to have no time.
- Add the ability to edit individual trips ([#7](https://github.com/dasdware/dw_bike_trips_client/issues/7))

### Fixes

- Allow integer values from API in dashboard ([#14](https://github.com/dasdware/dw_bike_trips_client/issues/14))

## [0.9.1] - 2023-02-05

### Added

- Selected [MIT](https://spdx.org/licenses/MIT.html) license for this repository
- Basic support for desktop plattforms ([#11](https://github.com/dasdware/dw_bike_trips_client/issues/11))
- Editing and reverting changes in the upload queue ([#12](https://github.com/dasdware/dw_bike_trips_client/issues/12))

## Changed

- Updated to current Flutter version ([#11](https://github.com/dasdware/dw_bike_trips_client/issues/11))

### Fixes

- Improved error handling ([#9](https://github.com/dasdware/dw_bike_trips_client/issues/9))

## [0.9.0] - 2022-01-26

Initial release version of the dasd.ware BikeTrips Client. Contains the following functionality:

- Management of hosts to which the client can connect.
- Logging in to a selected (active) host.
- Viewing simple statistics in a dashboard.
- Adding new trips with timestamp and distance.

[unreleased]: https://github.com/dasdware/dw_bike_trips_client/compare/v0.9.1...HEAD
[0.10.0]: https://github.com/dasdware/dw_bike_trips_client/releases/tag/v0.10.0
[0.9.1]: https://github.com/dasdware/dw_bike_trips_client/releases/tag/v0.9.1
[0.9.0]: https://github.com/dasdware/dw_bike_trips_client/releases/tag/v0.9.0
