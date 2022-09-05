/* Copyright 2016 Google Inc.

  Licensed under the Apache License, Version 2.0 (the "License");
  you may not use this file except in compliance with the License.
  You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

  Unless required by applicable law or agreed to in writing, software
  distributed under the License is distributed on an "AS IS" BASIS,
  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
  See the License for the specific language governing permissions and
  limitations under the License. */

#include "nsync_cpp.h"
#include "platform.h"
#include "compiler.h"
#include "cputype.h"
#include "nsync.h"
#include "dll.h"
#include "sem.h"
#include "wait_internal.h"
#include "common.h"
#include "atomic.h"

NSYNC_CPP_START_

/* Wait until one of:
     w->sem is non-zero----decrement it and return 0.
     abs_deadline expires---return ETIMEDOUT.
     cancel_note is non-NULL and *cancel_note becomes notified---return ECANCELED. */
int nsync_sem_wait_with_cancel_ (waiter *w, nsync_time abs_deadline,
			         nsync_note cancel_note) {
	int sem_outcome;
	if (cancel_note == NULL) {
		sem_outcome = nsync_mu_semaphore_p_with_deadline (&w->sem, abs_deadline);
	} else {
		nsync_time cancel_time;
		cancel_time = nsync_note_notified_deadline_ (cancel_note);
		sem_outcome = ECANCELED;
		if (nsync_time_cmp (cancel_time, nsync_time_zero) > 0) {
			struct nsync_waiter_s nw;
			nw.tag = NSYNC_WAITER_TAG;
			nw.sem = &w->sem;
			nsync_dll_init_ (&nw.q, &nw);
			ATM_STORE (&nw.waiting, 1);
			nw.flags = 0;
			nsync_mu_lock (&cancel_note->note_mu);
			cancel_time = NOTIFIED_TIME (cancel_note);
			if (nsync_time_cmp (cancel_time, nsync_time_zero) > 0) {
				nsync_time local_abs_deadline;
				int deadline_is_nearer = 0;
				cancel_note->waiters = nsync_dll_make_last_in_list_ (
					cancel_note->waiters, &nw.q);
				local_abs_deadline = cancel_time;
				if (nsync_time_cmp (abs_deadline, cancel_time) < 0) {
					local_abs_deadline = abs_deadline;
					deadline_is_nearer = 1;
				}
				nsync_mu_unlock (&cancel_note->note_mu);
				sem_outcome = nsync_mu_semaphore_p_with_deadline (&w->sem,
					local_abs_deadline);
				if (sem_outcome == ETIMEDOUT && !deadline_is_nearer) {
					sem_outcome = ECANCELED;
					nsync_note_notify (cancel_note);
				}
				nsync_mu_lock (&cancel_note->note_mu);
				cancel_time = NOTIFIED_TIME (cancel_note);
				if (nsync_time_cmp (cancel_time,
						    nsync_time_zero) > 0) {
					cancel_note->waiters = nsync_dll_remove_ (
						cancel_note->waiters, &nw.q);
				}
			}
			nsync_mu_unlock (&cancel_note->note_mu);
		}
	}
	return (sem_outcome);
}

NSYNC_CPP_END_
