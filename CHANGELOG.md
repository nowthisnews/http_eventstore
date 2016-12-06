# 1.0.0 2016-12-06
Make forward readers consistent. Make sure to ReadStreamEventsForward return events in
correct order: from oldest to newest.

It's a breaking change for other gems.


## 0.2.0 2016-11-23
* Add hurtle file
* Add gem version file
* Add http adapter option to specify http client which will be used to send requests to eventstore
- the default Net::Http lib have some problems in docker env.


