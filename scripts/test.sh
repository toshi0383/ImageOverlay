#!/bin/bash
set -eo pipefail
xcodebuild -scheme ImageOverlayTests -destination "platform=tvOS Simulator,id=158D173B-15A1-4534-9E57-85C25289E2F7" build-for-testing
for identifier in 54B31386-9EF3-4CDD-B8FF-38C50B32353E 158D173B-15A1-4534-9E57-85C25289E2F7
do
    xcodebuild -scheme ImageOverlayTests -destination "platform=tvOS Simulator,id=${identifier}" test-without-building
done
