#!/usr/bin/env python

# Setup options for display when running `wafl --help`
def options(ctx):
    ctx.load("flambe")

# Setup configuration when running `wafl configure`
def configure(ctx):
    ctx.load("flambe")

# Runs the build!
def build(ctx):
    platforms = ["flash", "html"]

    # Only build mobile apps if the required tools are installed
    if ctx.env.has_android: platforms += ["android"]
    if ctx.env.has_ios: platforms += ["ios"]

    # Kick off a build with the desired platforms
    ctx(features="flambe",
		 flags="-lib polygonal-ds -lib polygonal-core -lib nape",
        platforms=platforms,
        air_password="samplePassword")
