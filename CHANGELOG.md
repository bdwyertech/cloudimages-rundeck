CloudImages-RunDeck Changelog
=========================
This file is used to list changes made in each version of the `cloudimages-rundeck` gem.

v0.1.3 (2016-10-28)
-------------------
### Improvements
- Added Image Cleanup endpoint - ` POST /images/v1/cleanup`
  - Use the `filter` query_param to filter the images
  - Use the `keep` query_param to specify how many images to keep
  - If either of these are not specified, the return will be null
  - Currently sorts by ImageID in descending order.  The first `keep` images will be kept

v0.1.2 (2016-10-07)
-------------------
### Bug Fixes
- Fixed value return for RunDeck consumption -- It only likes string values, not integers.

v0.1.1 (2016-10-06)
-------------------
### Improvements
- Security: Add ability to check if a string is an existing file, and return its content.  This keeps keys out of config files.

v0.1.0 (2016-10-06)
-------------------
- Initial Release