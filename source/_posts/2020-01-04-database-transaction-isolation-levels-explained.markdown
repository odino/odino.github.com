---
layout: post
title: "Database transaction isolation levels explained"
date: 2020-01-04 15:07
comments: true
categories: [database, rdbms]
description: "A short explainer on what transaction isolation levels are, and how they help manage transaction concurrency."
published: false
---

Transactions are a very important concept when
dealing with manipulating data: they allow to perform
a series of operation so that they are all committed
(or rolled back) as a single unit of work. A simple
example would be a bank transfer, where $100 are
deducted from account A and deposited in account B
through 2 separate `UPDATE` queries: without a transaction,
our data might be left in an inconsistent state,
where one of the accounts containes more (or less)
money than it should.

Since trasactions play a very important role in
the way we interface with storage systems these days,
I wanted to spend some time describing how databases
allow us to execute transactions concurrently through
a series of "rules", the so-called transaction isolation
levels.

<!-- more -->

## The need for isolation levels

We shouldn't even be bothered
by isolation levels if all of our interactions with
data were to happen sequentially: isolation levels,
in fact, are only useful when transactions need to
happen concurrently -- which, wink wink, happens in
99% of the software we write. 

The need for isolation levels stems from the idea
that transactions can happen concurrently, and need
to be somewhat isolated from each other. Before
digging into the most widely used isolation levels
out there is important to understand what are the
problems they try to solve -- only then we can
both understand their goal and pick the level that
suits our needs.

All the following scenarios assume there are 2
transactions, T1 and T2, happening concurrently.
To keep things simple, our DB only containes
a `user` table with 3 fields: `id`, `email`, `version` and
`created_at`.

### Dirty reads

T1 could start and update the user record `1`, changing
its email. Before committing, T2 could read the row
and see the new email address set by T1, before the
transaction was committed. If T1 gets rolled back, T2
ended up reading "false" data.

This is called a **dirty read**, as it allows a transaction
to read changes that weren't committed.

### Non-repeatable reads

T1 could start and read user's `1` record, while T2
modifies it and commits. If T1 tries to re-read the
record, it will now see those changes. This means that the
same query issued at different stages during the transaction
could return different results. This situation is called
a **nonrepeatable read**.

### Phantom reads

T1 could start and read all users that were created recently
(`WHERE created_at > ...`), counting `N` records; at this point,
T2 could insert a new user record and commit.

If T1 was to re-issue the same query, it would now see `N+1`
records -- highlighting the fact that the transaction has not
ran without others "interfering".

This situation is called a **phantom read**, and it's a special
case of a **nonrepeatable read** which happens on a set of records rather
than a single one. In both cases, a query returns results that
are influenced by other transactions that manipulate the data
after a transaction starts and commit before it ends.

### Lost update

There could be a scenario where T1 reads a user row and updates
it, setting it's version to `N+1`. If T2 runs concurrently
and reads the same initial version number before T1 commits, it will
also end up updating the version to `N+1`. While the row
has been updated twice, its version is set to `N+1` as
opposed to `N+2`.

This is called a **lost update**.

### Write skew

The example we used for the **lost update** is in the context of a very simplistic,
consequence-free scenario, but you can see how it could create major troubles: swap the `version`
field with a `bank_account_balance` and think of the 2 transactions
as deposits into your account...this is sometimes referred to as
a **write skew**, a condition where the data is left in a sort of
logically inconsistent state.

### Dirty write

After a **dirty read** from T2, T1 could eventually end up updating
the row based on the (incorrect) value it obtained. This is referred
to as a **dirty write**.

## Isolation levels

### Read uncommitted

### Read committed

### Repeatable read

### Serializable

## Reference table

## That's a wrap!